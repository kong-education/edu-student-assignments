# Group Project

We will be deploying a brand-new set of applications for our organization, Kong Air.

All learners will be divided into several teams, each responsible for publishing their application information to a unified Developer Portal.

Each team will be tasked with ensuring their OAS (OpenAPI Specification) is completed correctly, executing all necessary conversions, and building the required Terraform files.

Once this is complete, each team will apply their configurations declaratively using Terraform.

Finally, we will register on the new Developer Portal and create an application to observe how the access process works.

## Instructions

### Team Assignments

The instructor will divide the class into two or more teams.

### Gateway Configuration Instructions

These steps can only be run from one Strigo machine. Therefore, the team must select a person to perform the following steps.

1. View the project files

   ```shell
   tree /home/ubuntu/KDIL-202/project/kongair_teams
   ```

2. Inspect the Terraform auth configuration. (You will see that the Konnect access token is set via an environment variable).

   ```shell
   cat /home/ubuntu/KDIL-202/project/kongair_teams/flights/auth.tf
   ```

3. In order to apply our config we need to set the access token first. We can do so as follows:

   ```shell
   export TF_VAR_PLATFORM_SPAT=<value provided by instructor>
   ```

4. Open the *variables.tf* file and enter the *Control Plane ID* and *Portal ID* provided by the platform team.
5. Open the *openapi.yaml* file.
6. Adjust the *openapi.yaml* file to route traffic:

   ```yaml
   servers:
   - url: <Proxy URL> ## ADDRESS OF GATEWAY FROM OPS TEAM
     description: KongAir API Server

   x-kong-service-defaults:
     host: <Strigo Lab FQDN> #FQDN FROM OPS TEAM
     port: <change me>
     protocol: http
   ```

   **Note:** The port configuration is application-specific, so ensure you use the correct port:

   ```text
   customer 5051
   flights 5052
   routes 5053
   bookings 5054
   ```

7. Lint the OpenAPI Specification and make the necessary fixes. You have two options:
   - Lint the spec using the *inso* CLI in Strigo, then make the necessary changes.
   - Lint using Insomnia. **Note:** Since Insomnia is not accessible in the Strigo environment, you will need to copy the spec into Insomnia locally, fix it, and then copy it back into the Strigo environment.
8. Convert the OAS spec to a decK file. Example:
   ```shell
   deck file openapi2kong --spec ./openapi.yaml --output-file ./flights_deck.yaml
   ```
   **Note:** Make sure you name the deck file correctly according to your team, i.e. customer,flights,routes,booking
   
9. Convert the decK file to Terraform configuration. Example:
   ```shell
   deck file kong2tf -s ./flights_deck.yaml -o flights.tf
   ```
   **Note:** Make sure you name the Terraform file correctly according to your team, i.e. customer,flights,routes,booking

10. Inject your product name into the *application_template.tf* file with the following commands:

    **Note:** It is important to set the name correctly. This value should only be one of the following depending on your team:
    - *flights*
    - *routes*
    - *customer*
    - *bookings*

    ```shell
    export PRODUCT="<team name>"
    ```

    ```shell
    envsubst < application_template.tf > application_template.tmp && \
    mv application_template.tmp application_template.tf
    ```

11. Perform the standard Terraform steps: `Init -> Plan -> Apply`.
12. Verify with the platform team that your API product has been published.

### Developer Portal Instructions

Next, we need to view the spec on the Developer Portal, register for an application, and obtain a key to use the service.

1. Register on the new portal (get the link from the instructor).
2. Create an application for your API. **Note:** The instructor will need to approve your request.
3. Generate a credential.
4. Using your credential, test your access and verify that the gateway is routing to your application properly.
5. View the analytics for your API product in Konnect Analytics.