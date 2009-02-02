
basedir=$1
test_cmd=$basedir/in_time.sh

set -x
$test_cmd 5 20 5 &&
! $test_cmd 5 20 4 &&
$test_cmd 5 20 19 &&
! $test_cmd 5 20 20 &&
! $test_cmd 20 5 19 &&
$test_cmd 20 5 20 &&
$test_cmd 20 5 4 &&
! $test_cmd 20 5 5 &&
$test_cmd 20 20 20 &&
! $test_cmd 20 20 19 &&
echo "test passed!!" && exit

echo "test failed!!"
