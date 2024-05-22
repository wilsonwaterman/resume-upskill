import json
import boto3
from decimal import Decimal

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('site-visitor-count-table')
tableName = 'site-visitor-count-table'


def lambda_handler(event, context):
    print(event)
    statusCode = 200
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,PUT"
    }

    try:
        if event['routeKey'] == "PUT /add":

            try:
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

            except KeyError:
                body = 'Add visitor_count key and first visit'
                # Below code will add the new entry with id count and value called visitor name, value 1 as a string
                table.put_item(Item={'id' : 'count','visitor_count' : '1'})
                return json.dumps(body)
        
        elif event['routeKey'] == "GET /visitors":
            response = table.get_item(Key={'id' : 'count'})
            count = response["Item"]["visitor_count"]

            # Show visitor count result
            return {'Current visitor count':count}
        
    except KeyError:
        if statusCode == 400:
            statusCode = 400
            body = 'Unsupported route: ' + event['routeKey']
            return json.dumps(body) 
        elif statusCode == 500:
            statusCode = 500
            body = 'Internal Error, gotta fix the gateway for: ' + event['routeKey']
            return json.dumps(body)
        else:
            body = 'No idea what the fuck is wrong with this request'
            return json.dumps(body)