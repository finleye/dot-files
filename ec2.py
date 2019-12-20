import sys
import boto3
import os

region = 'us-east-1'

defaultInstances = [os.environ['INSTANCE_ID']]
ec2 = boto3.client('ec2', region_name=region)

def stop(instances):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))

def start(instances):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))

def status(instances):
    response = ec2.describe_instances()
    for res in response['Reservations']:
        print("****", res['Instances'][0]['InstanceId'], "****")
        print("Type:", res['Instances'][0]['InstanceType'])
        print("Private IP:", res['Instances'][0]['PrivateIpAddress'])
        print("DNS:", res['Instances'][0]['PublicDnsName'])
        print("")

def dns(instances):
    response = ec2.describe_instances(InstanceIds=instances)
    print(response['Reservations'][0]['Instances'][0]['PublicDnsName'])

def main():
    args = sys.argv[1:]
    first = args[0]

    instances = [args[1]] if len(args) > 1 else defaultInstances

    if first == "start":
        print("Starting: ", instances)
        start(instances)
    elif first == "stop":
        print("Stopping: ", instances)
        stop(instances)
    elif first == "status":
        print("Fetching status")
        status(instances)
    elif first == "dns":
        dns(instances)
    else:
        print(first, "is not supported")

if __name__ == "__main__":
    main()
