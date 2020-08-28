export PATH=$PATH:/usr/local/go/bin;

echo "fetching..." && \
  git fetch && \
  echo "resetting..." && \
  git reset --hard origin/master && \
  echo "patching Makefile..." && \
  sed -i '1s/^/.PHONY: build\n/' Makefile && \
  sed -i 's/go build/go build -o .\/build\//g' Makefile && \
  echo "building..." && \
  make build
