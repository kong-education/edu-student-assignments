# Kong Developer Project

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

1. Using the Strigo editor, navigate to the *kongair_teams* folder at:

   ```text
   /home/ubuntu/KDIL-202/assignment/kongair_teams
   ```

2. Each folder is named after an API. Select the one your team was assigned to.
3. Set the access token. This value is defined in the *auth.tf* file and is set using an environment variable:

   ```shell
   export TF_VAR_PLATFORM_SPAT=<value provided by instructor>
   ```

4. Open the *variables.tf* file and enter the *Control Plane ID* and *Portal ID* provided by the instructor.
5. Open the *openapi.yaml* file.
6. Adjust the *openapi.yaml* file to route traffic:

   ```yaml
   servers:
   - url: <Proxy URL> ## ADDRESS OF GATEWAY FROM OPS TEAM
     description: KongAir API Server

   x-kong-service-defaults:
     host: <Strigo Lab FQDN>
     port: <change me>
     protocol: http
   ```

   To get the FQDN, run the following command:

   ```shell
   echo $FQDN
   ```

   The port configuration is application-specific, so ensure you select the correct port:

   ```text
   Experience 5050
   Customer 5051
   Flights 5052
   Routes 5053
   Bookings 5054
   ```

7. Lint the OpenAPI Specification and make the necessary fixes. You have two options:
   - Lint the spec using the *inso* CLI in Strigo, then make the necessary changes.
   - Lint using Insomnia. **Note:** Since Insomnia is not accessible in the Strigo environment, you will need to copy the spec into Insomnia locally, fix it, and then copy it back into the Strigo environment.

8. Convert the OAS spec to a decK file. Example:

   ```shell
   deck file openapi2kong --spec ./openapi.yaml --output-file ./flights_deck.yaml
   ```

9. Convert the decK file to Terraform configuration. Example:

   ```shell
   deck file kong2tf -s ./flights_deck.yaml -o flights.tf
   ```

10. Inject your product name into the *application_template.tf* file with the following commands:

    ```shell
    export PRODUCT="xyz"
    ```

    ```shell
    envsubst < application_template.tf > application_template.tmp && \
    mv application_template.tmp application_template.tf
    ```

    **Note:** It is important to set the name correctly. This value should only be one of the following depending on your team:
    - *flights*
    - *routes*
    - *customer*
    - *bookings*

11. Perform the standard Terraform steps: `Init -> Plan -> Apply` (in Strigo).
12. Verify with the platform team that your API product has been published.

### Developer Portal Instructions

Next, we need to view the spec on the Developer Portal, register for an application, and obtain a key to use the service.

1. Register on the new portal (get the link from the instructor).
2. Create an application for your API. **Note:** The instructor will need to approve your request.
3. Generate a credential.
4. Using your credential, test your access and verify that the gateway is routing to your application properly.
5. View the analytics for your API product in Konnect Analytics.

### BONUS TASK

1. Make an adjustment to your OAS.
2. Run through the process above again.
3. Promote your new API product version and deprecate the old version.
