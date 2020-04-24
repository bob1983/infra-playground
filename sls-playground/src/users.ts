import { APIGatewayProxyHandler, } from 'aws-lambda';
import 'source-map-support/register';

const mockUsers = [
  { id: 1, firstName: 'John', lastName: 'Doe' },
  { id: 2, firstName: 'Jane', lastName: 'Doe' }
]

export const getUsers: APIGatewayProxyHandler = async (_event, _context) => {
  return {
    statusCode: 200,
    body: JSON.stringify(mockUsers, null, 2),
  };
}
