# OpenShift 4 UPI

A repository of artifacts to improve the experience of install OpenShift 4
using the User-Provisioned Infrastructure (UPI) method of deployment.

## AWS

The [OpenShift 4 documentation][1] for UPI provides a collection of
CloudFormation templates to deploy OpenShift 4 infrastructure components.
However, these CloudFormation templates do not exactly represent the setup that
you would get if you were to do use the Installer-Provision Infrastructure
(IPI) method of deployment. Namely, it names things differently and misses
quite a few tags that are critical to ensuring that you can take advantage of
all cloud integration features in OpenShift 4.

To improve that experience and to ensure the infrastructure provided by default
matches as closely as possible to what you would get if you used the IPI method
of deployment, this repository includes modified versions of each of the
CloudFormation templates to fix those issues.

You can find the templates here:

| Template                 | Original                                                             | Modified                                                    |
| ------------------------ | -------------------------------------------------------------------- | ----------------------------------------------------------- |
| VPC                      | [original](playbooks/aws/cloudformation/vpc.original.yaml)           | [modified](playbooks/aws/cloudformation/vpc.yaml)           |
| Security                 | [original](playbooks/aws/cloudformation/security.original.yaml)      | [modified](playbooks/aws/cloudformation/security.yaml)      |

Also included is a playbook that ties each of the CloudFormation templates
together by matching the outputs of CloudFormation stacks to parameters to
templates that run later in the process, including taking user input for
required parameters and some optional parameters.

Example variable file:

```yaml
---

###############################################################################
# Required Variables
###############################################################################

cluster_name: example
base_domain: redhat.com
infrastructure_name: example

hosted_zone_name: "{{ base_domain }}"

###############################################################################
# Optional Variables
###############################################################################

vpc_cidr: 10.0.0.0/16
availability_zone_count: 3
subnet_bits: 12

allowed_bootstrap_ssh_cidr: 0.0.0.0/0

```
----------------------------------------------------
Build Sparta VPC:
```
mkdir sparta-vpc
```
```
podman run -it --rm -v $(pwd)/sparta-vpc:/clone:z \
  quay.io/cloudctl/git --branch master https://github.com/CodeSparta/prometheus.git
```
```
cd sparta-vpc
```
```
vi playbooks/aws/vars/aws.yml
```
```
./build-vpc-aws.sh -vv -e aws_cloud_region=us-gov-west-1 -e aws_access_key=xxxxxxxxxxxxx -e aws_secret_key=XXXXXXXXXXXXXXXXX
```

----------------------------------------------------
Destroy Sparta VPC:

```bash
./destroy-vpc-aws.sh
```

[1]: https://docs.openshift.com/container-platform/latest/installing/installing_aws/installing-aws-user-infra.html
