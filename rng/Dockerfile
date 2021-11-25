FROM python:alpine
RUN pip install Flask

FROM scratch
COPY --from=0 / /
