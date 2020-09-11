# Patient Health Records - App Modernization with RedHat OpenShift

Used in IBM Solution Tutorial: [Deploy microservices with OpenShift](https://cloud.ibm.com/docs/solution-tutorials?topic=solution-tutorials-openshift-microservices)

## Scripts to automate the steps in the tutorial

### Step 1 - Create an OpenShift cluster
Follow the instructions in the tutorial to create the cluster.  Then create and edit the config.sh file used in the rest of the steps.

```
cd scripts
cp config.sh.template config.sh
edit config.sh
```

### Step 2 - Deploying an application - scripts/020-frontend.sh
The script will do the following:
- create a new project
- create a new application
- wait for application pods to be replicated
- expose frontend
- display routes

In the OpenShift console navigate to Developer/Topology view and verify that the resources created in the script match the expeted results shown in the tutorial.

### Step 3 - Logging and monitoring - scripts/load.sh
Follow the instructions in the tutorial use scripts/load.sh to generate load

### Step 4 - Metrics and dashboards
Follow the instructions in the tutorial use scripts/load.sh to generate load

### Step 5 - Scaling the application - scripts/050-autoscale.sh
The script will do the following:
- patch deployment config with limmits and requests
- configure autoscaling

Compare the results with the tutorial expected results.  Check out the Administrator/Installed Operators and the Developer/Topology views.

Generate load using ./scripts/load.sh.  

Back in the OpenShift console verify the patient-health-frontend DeployConfig shows the pod scaling after a few minutes.

### Step 6 - Using the IBM Cloud Operator to create a Cloudant DB - scripts/060-operator-backend.sh
The script will do the following:
- create the ibm operator
- create the secret
- create the cloudant service using the ibm operator
- bind the secret
- create backend
- wait for secret to exist
- connect backend to the cloudant using the bound secret
- connect frontend to backend

Notice the `open http://patient-health-frontend-example-health...` string displayed by the script.  Open the url in the browser.  It can take a few minuts for it to work.  Then try to login as opall/opall logout and then as luet/luet

Back in the OpenShift console compare the results with the tutorial expected results.  Berify the patient-health-backend was created for example

### Step 7, 8, ...
### Step 11 - Remove resources - scripts/destroy.sh

At any time during the tutorial execute this script to start over.


## Background

This project is a patient records user interface for a conceptual health records system. The UI is programmed with open standards JavaScript and modern, universal CSS, and HTML5 Canvas for layout.

The UI is served by a simple Node.JS Express server, and the overall project goals are:

- to use the project to show a step by step guide of deploying the app on OpenShift Source to Image ( S2I )
- to illustrate the versatility of Kubernetes based micro services for modernizing traditional applications - for instance mainframe based applications, or classic Java app server applications
- to experiment and explore open standards front end technologies for rendering custom charts, and for responsive design

This project stands alone in test mode, or integrates with associated projects [ paths to other projects ]

![architecture](./design/app-modernization-openshift-s2i-architecture-diagram.png)


#### Example Health Background Story

Example Health is a pretend, conceptual healthcare/insurance type company. It is imagined to have been around a long time, and has 100s of thousands of patient records in an SQL database connected to a either a mainframe, or a monolithic Java backend.

The business rules for the system is written in COBOL or Java. It has some entitlement rules, prescription rules, coverage rules coded in there.

Example's health records look very similar to the health records of most insurance companies.

Here's a view a client might see when they log in:

![screenshot](./design/mockup.png)

Example Health business leaders have recently started understanding how machine learning using some of the patient records, might surface interesting insights that would benefit patients. There is lots of talk about this among some of the big data companies.

https://ai.googleblog.com/2018/05/deep-learning-for-electronic-health.html

https://blog.adafruit.com/2018/04/16/machine-learning-helps-to-grok-blood-test-results/

### Running locally
See [Makefile](./Makefile)
```
oc expose service patient-health-backend
export API_URL=http://$(oc get routes patient-health-backend --output json | jq -r '.status.ingress[0].host')/
echo $API_URL
npm start
```
