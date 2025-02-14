# Free env

This environment deploys free-tier compute resources from public cloud providers.

## Components

- aws: no completely free stuffs so not deployed by default
- gcp:
    - 1x instance (e2-micro) with 30GB storage (pd-standard)
- oci:
    - 2x AMD isntances (VM.Standard.E2.1.Micro) with 1 VCPU, 1GB RAM and 50GB storage
    - 2x ARM instances (VM.Standard.A1.Flex) with 2 VCPU, 12GB RAM and 50GB storage
