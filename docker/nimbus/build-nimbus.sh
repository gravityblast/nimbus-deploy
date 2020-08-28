export NIMFLAGS="-d:insecure";

echo "fetching..." && \
  git fetch && \
  echo "resetting..." && \
  git reset --hard origin/devel && \
  echo "updating..." && \
  make update && \
  echo "building... (NIMFLAGS: $NIMFLAGS)" && \
  make beacon_node
