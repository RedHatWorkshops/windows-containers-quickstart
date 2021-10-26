# OpenShift Windows Containers

Welcome to the OpenShift Windows Containers quickstart demo guide!

This guide is meant to help you to see what you can (and also cannot) do with Windows Containers on OpenShift 4.6. This will eventually turn into a workshop the closer we get to GA.

A few things before we get started; You should have gotten an email from the RHPDS system. I'm assuming you have or else how else would you be reading this? :)

That email has all the information you need in order to test/demo Windows Containers. This includes instructions on how to ssh into the bastion host. Go ahead and do that now. Example:

```shell
ssh chernand-redhat.com@bastion.lax-e35b.sandbox886.opentlc.com
```

When it prompts you for a password; go ahead and provide the password given to you in the email. I suggeest you copy over your ssh key to make things easier. All commands in this guide assume you're on this bastion host, except where otherwise stated.

Once you're in, become the `ec2-user`.

```shell
sudo su - ec2-user
```

Once you're in, you're ready to begin!
