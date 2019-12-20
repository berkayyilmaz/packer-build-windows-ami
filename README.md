# packer-build-windows-ami
Windows AMI Creation with Packer

## Objective ##
* Build Ubuntu AMI using Packer and provision software

## Prerequisites
* Packer is installed
* Understand JSON file structure
* Knowledge about environment variables
* Basics of powershell

Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. What is [packer](https://www.packer.io/intro/)? How to [install](https://www.packer.io/intro/getting-started/install.html)? Learn Packer [template](https://www.packer.io/docs/templates/index.html).

## File Structure
| File Name                     | Purpose                                                        |
| -------------                 |:-------------                                                  |
| base_ami.json                 | A JSON file which is used by Packer to build Windows based AMI |
| variables.json                | Variables file which are used in Packer template               |
| scripts/bootstrap_win.txt     | PowerShell script in order to setup WinRM connection           |
| scripts.ps1                   | This provisioner scripts which read S3 bucket and install ESET |

## Building Packer
In order to compile there are some options for Packer. If you want to build just type:

```
packer build -var-file variables.json base_ami.json
```

There is also option which you can start in DEBUG mode.

```
PACKER_LOG=1 packer build -var-file variables.json base_ami.json
```

The ```packer console``` command allows you to experiment with Packer variable interpolations. You can use this feature for checking variables.

```
packer console -var-file variables.json base_ami.json
> {{ user `region` }}
> eu-central-1
```
