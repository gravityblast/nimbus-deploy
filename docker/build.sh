echo "fetching..." && \
  git fetch && \
  echo "resetting..." && \
  git reset --hard origin/devel && \
  echo "updating..." && \
  make update && \
  echo "building..." && \
  make beacon_node
