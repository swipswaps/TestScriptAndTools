function get_value {
  key=$1
  value=$(jq '.'$key config.json)
  value=$(echo $value | tr -d \")
  echo $value
}

ORIGIN_SERVER=$(get_value 'ORIGIN_SERVER')
EDGE_ACCESS_POINT=$(get_value 'EDGE_ACCESS_POINT')
TEST_FILE=$(get_value 'TEST_FILE')
DURATION=$(get_value 'DURATION')
LOAD_SIZE=$(get_value 'LOAD_SIZE')
STREAM_NAME=$(get_value 'STREAM_NAME')

echo ORIGIN_SERVER=$ORIGIN_SERVER
echo EDGE_ACCESS_POINT=$EDGE_ACCESS_POINT
echo TEST_FILE=$TEST_FILE
echo DURATION=$DURATION
echo LOAD_SIZE=$LOAD_SIZE
echo STREAM_NAME=$STREAM_NAME

