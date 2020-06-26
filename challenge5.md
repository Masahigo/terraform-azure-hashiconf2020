# Solution

## Provision Consul cluster and expose to public ip using terraform

```bash
cd challenges/challenge5/terraform
terraform init
terraform apply -auto-approve
```

## Verify things work

```bash
$ kubectl get services
NAME                  TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                                                                   AGE
azure-load-balancer   LoadBalancer   10.0.72.220    40.113.118.88   8302:31346/TCP                                                            11m
consul-dns            ClusterIP      10.0.158.119   <none>          53/TCP,53/UDP                                                             87m
consul-server         ClusterIP      None           <none>          8500/TCP,8301/TCP,8301/UDP,8302/TCP,8302/UDP,8300/TCP,8600/TCP,8600/UDP   87m
consul-ui             ClusterIP      10.0.151.73    <none>          80/TCP                                                                    87m
kubernetes            ClusterIP      10.0.0.1       <none>          443/TCP                                                                   9h
ttweb                 ClusterIP      10.0.171.211   <none>          80/TCP                                                                    8h

$ kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
consul-7jc46                             1/1     Running   0          64m
consul-server-0                          1/1     Running   0          87m
tailwindtraders-tt-web-95dff454d-fpd9g   1/1     Running   0          8h

$ kubectl exec -it consul-server-0 sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
/ # consul members -wan
Node                      Address           Status  Type    Build  Protocol  DC        Segment
consul-server-0.masahigo  10.244.0.15:8302  alive   server  1.8.0  2         masahigo  <all>
```
