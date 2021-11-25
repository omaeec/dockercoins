FROM python:alpine
USER nobody
RUN pip install Flask

FROM scratch
COPY --from=0 / /
