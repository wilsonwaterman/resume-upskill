import json
import boto3
from decimal import Decimal

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('site-visitor-count-table')
tableName = 'site-visitor-count-table'


def lambda_handler(event, context):
    print(event)
    # body={}
    # statusCode = 200
    # headers = {
    #     "Content-Type": "application/json"
    # }

    try:
        if event['routeKey'] == "GET /add":
            response = table.get_item(Key={'id' : 'count'})
            count = response["Item"]["visitor_count"]
        
            # Increment the count on visit / get
            new_count = str(int(count)+1)
            response = table.update_item(
                Key={'id': 'count'},
                UpdateExpression='set visitor_count = :c',
                ExpressionAttributeValues={':c': new_count},
                ReturnValues='UPDATED_NEW'
            )

            return {'Count':new_count}
        
        elif event['routeKey'] == "GET /visitors":
            response = table.get_item(Key={'id' : 'count'})
            count = response["Item"]["visitor_count"]

            return {'Current visitor count':count}
        
    except KeyError:
        statusCode = 400
        body = 'Unsupported route: ' + event['routeKey']
        return json.dumps(body) 