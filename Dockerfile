FROM isaitb/xml-validator:latest
COPY resources /validator/resources/eira
ENV validator.resourceRoot /validator/resources