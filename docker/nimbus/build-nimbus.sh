export MAKE_BUILD_TARGET=nimbus_beacon_node;
export NIMFLAGS="-d:insecure";

echo "fetching..." && \
  git fetch && \
  echo "resetting..." && \
  git reset --hard origin/stable && \
  echo "updating..." && \
  make update && \
  echo "building beacon_node... (TARGET: $MAKE_BUILD_TARGET - NIMFLAGS: $NIMFLAGS)" && \
  make $MAKE_BUILD_TARGET && \
  echo "building ncli_db..." && \
  make ncli_db
