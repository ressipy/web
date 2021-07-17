###
### Fist Stage - Building the Release
###
FROM elixir:1.12-alpine AS elixir-build

# install build dependencies
RUN apk add --no-cache build-base

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV as prod
ENV MIX_ENV=prod

# Copy over the mix.exs and mix.lock files to load the dependencies. If those
# files don't change, then we don't keep re-fetching and rebuilding the deps.
COPY mix.exs mix.lock ./
COPY config/config.exs config/prod.exs ./config/

RUN mix deps.get --only prod && \
    mix deps.compile

COPY lib lib

RUN mix compile --warnings-as-errors

###
### Second Stage - Build the Javascript parts
###
FROM node:lts-alpine AS js-build

WORKDIR /app

# set build ENV as prod
ENV NODE_ENV=prod

# copy over elixir deps since some JS stuff may be pulled from there
COPY --from=elixir-build /app/deps deps

# install npm dependencies
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# copy over all the static stuff to be built
COPY assets assets
COPY priv priv

# TailwindCSS purges any styles that aren't referenced in our HTML, so it needs
# to be able to see the templates to do that
COPY lib lib

# build assets
RUN npm run --prefix ./assets deploy

###
### Third Stage - Put the Pieces Together
###
FROM elixir-build AS release-build

WORKDIR /app

COPY --from=js-build /app/priv priv
COPY config/runtime.exs config/runtime.exs

# compile and build release
COPY rel rel
RUN mix do phx.digest, release

###
### Fourth Stage - Setup the Runtime Environment
###
FROM alpine:3.14 AS app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=release-build --chown=nobody:nobody /app/_build/prod/rel/ressipy ./

ENTRYPOINT ["/app/bin/ressipy"]
CMD ["start"]
