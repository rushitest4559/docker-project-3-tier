# this script is run when container starts for first time not run when restart
# it ensures environment variables needed for container to start are passed by user 
# if required environment variables don't pass by user container don't start, we can see the logs in exited container by docker logs <container_name>

#!/bin/sh

for var in REACT_APP_API_BASE_URL; do
  if [ -z "$(eval echo \$$var)" ]; then
    echo "🚫 ERROR: $var is missing! Pass it with -e $var=foo" >&2
    exit 1
  fi
done

echo "✅ All env vars good, launching app..."
exec "$@"
