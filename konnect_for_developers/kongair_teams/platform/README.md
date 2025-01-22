# Steps for Platform Setup

1. Login to Konnect.
2. Create a Personal Access Token (KPAT).
3. Export the token to an environment variable:

   ```shell
   export TF_VAR_PLATFORM_KPAT=<insert KPAT token here>
   ```

4. Navigate to Gateway Manager and select `serverless-default`.
5. Copy the *control plane id*.
6. Copy the gateway address.
7. Navigate to the platform folder.
8. In the variables.tf file, set the control plane id:

   ```tf
   variable "control_plane_id" {
   type = string
   default = "<serverless-cp-id>"
   }
   ```

9. Run `terraform init` in the folder.
10. Run `terraform apply`.

Once you have completed all of the steps, Terraform will output the following information, which must be shared with the API teams:

```text
control_plane_id = "<cp id>"
developer_sa_token = "<token>"
portal_id = "<portal id>"
portal_url = "<portal url>"
```
