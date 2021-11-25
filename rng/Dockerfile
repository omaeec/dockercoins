FROM python:alpine
USER nobody
WORKDIR /tmp/
RUN pip install Flask

FROM scratch
COPY --from=0 / /
