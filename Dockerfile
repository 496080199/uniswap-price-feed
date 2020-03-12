FROM python:3.6.8-alpine

RUN addgroup keeper&&adduser -D -G keeper keeper&&apk update&&apk --no-cache add --virtual build-dependencies build-base gcc wget git&&mkdir /keeper&&cd /keeper&&git clone https://github.com/makerdao/uniswap-price-feed.git &&cd uniswap-price-feed&&git submodule update --init --recursive&&pip install --no-cache-dir $(cat requirements.txt $(find lib -name requirements.txt | sort) | sort | uniq | sed 's/ *== */==/g') virtualenv&&apk del build-dependencies && apk --no-cache add bash libstdc++&&rm -rf /var/cache/apk/*&&rm -rf /tmp/pip*&&chown -R keeper.keeper /keeper


WORKDIR /keeper/uniswap-price-feed
USER keeper

RUN rm -rf _virtualenv&&virtualenv --system-site-packages _virtualenv&&sh _virtualenv/bin/activate

ENTRYPOINT ["bin/uniswap-price-feed"]
