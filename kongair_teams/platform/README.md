# Steps for Instructors

1) Create a new Konnect Org
2) Create a KPAT Token via the UI
3) Export the token to an environment variable

   ```shell
   export TF_VAR_PLATFORM_KPAT=<inert KPAT token here>
   ```

4) Navigate to Gateway Manager and select serverless-default (you may have to click through a tutorial once here)
5) Copy the Control Plane ID
6) Copy the Gateway Address
7) Navigate to the Platform folder in the Project folders
8) Update your auth.tf with the KPAT token you generated
9) Terraform init the folder
10) Terraform apply
11) Copy the Portal ID
12) Copy the Porta URL

Once you  have completed all of the steps, the terraform file will out the following information. 

```text
control_plane_id = "<cp id>"
developer_sa_token = "<token>"
portal_id = "<portal id>"
portal_url = "<portal url>"
```
