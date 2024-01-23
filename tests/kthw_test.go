package main

import (
	"context"
	"errors"
	"log"
	"os"
	"os/exec"
	"strconv"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/compute/armcompute"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v2"
	"golang.org/x/crypto/ssh"
)

const (
	subscriptionId    = "767c436e-682c-42c0-88f5-66d53a80176d"
	resourceGroupName = "kubernetes-the-hard-way"
)

type VM struct {
	privateIPAddress string
	publicIPAddress  string
	dnsName          string
}

func check(err error, message string) {
	if err != nil {
		log.Fatalf("%v: %v", message, err)
	}
}

func (vm VM) reachableOnPort(port int) (bool, error) {
	cmd := exec.Command("nc", vm.publicIPAddress, strconv.Itoa(port), "-w 1")

	_, err := cmd.Output()
	if err != nil {
		return false, errors.New("non-zero exit code from nc: " + err.Error())
	}

	return true, nil
}

func (vm VM) connectableOverSSH(publicKeyPath string) (bool, error) {
	key, err := os.ReadFile("../keys/id_rsa")
	check(err, "Unable to read private key file")

	signer, err := ssh.ParsePrivateKey(key)
	check(err, "Unable to parse private key file")

	config := &ssh.ClientConfig{
		User: "ubuntu",
		Auth: []ssh.AuthMethod{
			ssh.PublicKeys(signer),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}

	client, err := ssh.Dial("tcp", vm.publicIPAddress+":22", config)
	check(err, "Unable to connect to "+vm.publicIPAddress)
	defer client.Close()

	return true, nil
}

func vmFromName(name string) (VM, error) {
	var result VM

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	check(err, "Failed to get OAuth config")
	ctx := context.Background()

	vmClient, err := armcompute.NewVirtualMachinesClient(subscriptionId, credential, nil)
	check(err, "Failed to get compute client")

	vm, err := vmClient.Get(ctx, resourceGroupName, name, nil)
	check(err, "Could not retrieve instance view")

	nicRef := vm.Properties.NetworkProfile.NetworkInterfaces[0]
	nicID, err := arm.ParseResourceID(*nicRef.ID)
	check(err, "Unable to parse nic resource id")

	nicClient, err := armnetwork.NewInterfacesClient(subscriptionId, credential, nil)
	check(err, "Unable to get network interfaces client")

	nic, err := nicClient.Get(ctx, resourceGroupName, nicID.Name, nil)
	check(err, "Unable to get nic")

	for _, ipConfig := range nic.Properties.IPConfigurations {
		if ipAddress := ipConfig.Properties.PrivateIPAddress; ipAddress != nil {
			result.privateIPAddress = *ipAddress
		}
		if ipAddress := ipConfig.Properties.PublicIPAddress; ipAddress != nil {
			publicIPClient, err := armnetwork.NewPublicIPAddressesClient(
				subscriptionId,
				credential,
				nil,
			)
			check(err, "Could not initialise the public ip client")

			publicIPID, err := arm.ParseResourceID(*ipAddress.ID)
			check(err, "Could not parse the public ID resource ID")

			publicIP, err := publicIPClient.Get(ctx, resourceGroupName, publicIPID.Name, nil)
			check(err, "Could not get public IP address")

			result.publicIPAddress = *publicIP.PublicIPAddress.Properties.IPAddress
			result.dnsName = *publicIP.PublicIPAddress.Properties.DNSSettings.Fqdn
		}
	}

	return result, nil
}

func TestVMs(t *testing.T) {
	tests := []struct {
		vmName    string
		privateIP string
	}{
		{
			vmName:    "controller-1",
			privateIP: "10.240.0.11",
		},
		{
			vmName:    "controller-2",
			privateIP: "10.240.0.12",
		},
		{
			vmName:    "controller-3",
			privateIP: "10.240.0.13",
		},
		{
			vmName:    "worker-1",
			privateIP: "10.240.0.21",
		},
		{
			vmName:    "worker-2",
			privateIP: "10.240.0.22",
		},
		{
			vmName:    "worker-3",
			privateIP: "10.240.0.23",
		},
	}

	for _, tt := range tests {
		vm, err := vmFromName(tt.vmName)
		check(err, "Unable to get VM from name")

		t.Run(tt.vmName+" correct private IP", func(t *testing.T) {
			if vm.privateIPAddress != tt.privateIP {
				t.Errorf("Want %v, got %v", tt.privateIP, vm.privateIPAddress)
			}
		})

		reachable, err := vm.reachableOnPort(22)
		check(err, "Unable to check reachability of VM on port 22")
		t.Run(tt.vmName+" reachable on port 22", func(t *testing.T) {
			if !reachable {
				t.Errorf("%v: not reachable on port 22", tt.vmName)
			}
		})

		connectable, err := vm.connectableOverSSH("../0-keys/id_rsa.pub")
		check(err, "Unable to check SSH connectivity")
		t.Run(tt.vmName+" connectable over SSH", func(t *testing.T) {
			if !connectable {
				t.Errorf("%v: not connectable over ssh", tt.vmName)
			}
		})

		t.Run(tt.vmName+" correct DNS name", func(t *testing.T) {
			want := tt.vmName + "-kthw-cw.uksouth.cloudapp.azure.com"
			got := vm.dnsName
			if got != want {
				t.Errorf("want %v, got %v", want, got)
			}
		})
	}
}