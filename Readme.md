# vagrant_boxes

A set of ready-to-build minimal vagrant boxes.

## Presentation

This project contains all the necessary recipes to build (quite) minimal vagrant boxes. The available distributions are:
* debian 8 and 9
* centos 7

First, packer will download the minimal ISO, and run the installation process. Then a set of scripts will package the VM to be able to run under vagrant, and also to remove useless packages. Finally, the VM will be exported under the vagrant box format.

## Usage

You will need to have the following tools installed:
* [virtualbox](http://virtualbox.org)
* [vagrant](http://vagrantup.com)
* [packer](http://packer.io)

Once all the required dependencies installed, you can start to build the distribution of your choice, then you can add the newly created box to vagrant:

For a debian box:

    cd vagrant_boxes/debian
    packer build build-debian.json -var-file=[jessie|stretch].json
    vagrant box add --name=debian[7|8] output/vagrant/debian[7|8].box

For a centos box:

    cd vagrant_boxes/centos
    packer build build-centos.json -var-file=centos7.json
    vagrant box add --name=centos7 output/vagrant/centos7.box

You can now start to use your box !

## Credits:

* author: kevinwaro 
* contact: kevinwaro@yahoo.fr

## Licence

This project is licensed under the GNU GPLv3 License - see the [License.md](License.md) file for details