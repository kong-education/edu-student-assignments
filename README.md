# Kong Developer Project

We will be deploying a brand new set of applications for our organization, Kong Air

All learners will be divided up into several teams each in charge of publishing their application information to a unified Dev Portal

Each team will be responsible for ensuring their OAS spec is done correctly, all conversions are executed, and then Terraform files built out

Once all of that is complete, each team will apply their configurations declaratively via Terraform

We'll then register for our new Dev portal and create an application to see how the access process works

## Instructions

### Tean Assignments

The instructor divides the class into two or more teams.

### Gateway Configuration Instructions

These steps can only be run from one Strigo machine. So the team must select a person to perform the following steps.

1) Using the Strigo editor, navigate to the *kongair_teams* folder at */home/ubuntu/KDIL-202/project/kongair_teams*
2) Each folder is named after an API, select the one your team was assigned to.
3) Open the *auth.tf* file. Enter the provided PAT token where indicated and save the file.
4) Open the *variables.tf* file. Enter the *Control Plane Id* and *Portal Id* provided by the instructor.
5) Open the *openapi.yaml* file.
6) Adjust the  *openapi.yaml* to route traffic

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

    The port configuration is application specific, so make sure you select the correct port.

    ```text
    Experience 5050
    Customer 5051
    Flights 5052
    Routes 5053
    Bookings 5054
    ```

7) Lint the Open API Specification and make the necessary fixes. Here you have two options:
   a) Lint the spec using the *inso* cli in Strigo and then make the necessary changes.
   b) Lint using Insomnia. **Note:** As we don't have access to Insomnia via the Strigo environment, you will need to copy the spec into Insomnia locally, fix it, and then copy back into the Strigo environment.

8) Convert the OAS spec to a decK file. Example:

    ```shell
    deck file openapi2kong --spec ./openapi.yaml --output-file ./flights_deck.yaml
    ```

9) Convert the decK file to Terraform configuration. Example:

    ```shell
    deck file kong2tf -s ./flights_deck.yaml -o flights.tf
    ```

10) Inject your product name into the application_template.tf with the following commands:

    ```shell
    export PRODUCT="xyz"
    ```

    ```shell
    envsubst < application_template.tf > application_template.tmp && \
    mv application_template.tmp application_template.tf
    ```

    **Note:** It is important to set the name correctly. This value should only be one of the following depending on your team:
    *flights, routes, customer, bookings*

11) Perform our standard terraform steps. Init -> Plan -> Apply (Strigo)
12) Verify with platform team your API Product has been published

### Developer Portal Instructions

Next we need to view the spec on the developer portal, register for an application and obtain a key to user the service.

1) Register for the new portal (get link from instructor)
2) Create an application for your api. **Note:** The instructor will need to approve your request.
3) Generate a credential
4) Using your credential test your access and that the gateway is routing to our application properly
5) View the Analytics for your API Product in Konnect Analytics

### BONUS TASK

1) Make an adjustment to your OAS
2) Run through the above process again
3) Promote your new API Product version and deprecate the old version.
