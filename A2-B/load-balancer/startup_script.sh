cd /src
make clean
make

# If make does not fail
if [ $? -eq 0 ]
    then
    tail -F anything
fi