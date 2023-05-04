// case 400:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;

//         case 401:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;

//         case 422:
//           final errors = jsonDecode(response.body)['errors'];
//           apiResponse.error = errors[errors.keys.elementAt(0)][0];
//           break;

//         case 403:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;

//         case 500:
//           apiResponse.error = SERVER_ERROR;
//           break;

//         default:
//           apiResponse.error = SOMETHING_WENT_WRONG;
//           break;