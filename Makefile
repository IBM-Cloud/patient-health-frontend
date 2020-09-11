run:
	API_URL=http://$$(oc get routes patient-health-backend --output json | jq -r '.status.ingress[0].host')/ npm start

runlocal:
	PORT=8081 API_URL=http://localhost:8080/ npm start
