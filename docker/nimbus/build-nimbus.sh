export NIMFLAGS="-d:insecure";

echo "fetching..." && \
  git fetch && \
  echo "resetting..." && \
  git reset --hard origin/master && \
  echo "updating..." && \
  make update && \
  echo "building beacon_node... (NIMFLAGS: $NIMFLAGS)" && \
  make beacon_node && \
  echo "building ncli_db..." && \
  make ncli_db
