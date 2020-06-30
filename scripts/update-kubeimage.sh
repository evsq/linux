#!/bin/bash

SERVICE=$1

if [ "$SERVICE" = service ] ; then
    DEV_VERSION=$(kubectl --kubeconfig=$HOME/.kube/config -n somenamespace get deployment somedeploy -o=jsonpath='{$.spec.template.spec.containers[:1].image}')
    echo "Current version on dev somedeploy: " $DEV_VERSION
    PROD_VERSION=$(kubectl --kubeconfig=$HOME/.kube/prod.kubeconfig -n somenamespace get deployment somedeploy -o=jsonpath='{$.spec.template.spec.containers[:1].image}')
    echo "Current version on prod somedeploy: " $PROD_VERSION

    if [ "$PROD_VERSION" =! "$DEV_VERSION"] ; then
        echo "Update prod somedeploy"
        kubectl --kubeconfig=$HOME/.kube/prod.kubeconfig set image deployment/somedeploy somedeploy=$DEV_VERSION
    fi
fi
