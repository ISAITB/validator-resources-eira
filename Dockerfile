FROM isaitb/xml-validator:latest
COPY resources /validator/resources/validator
ENV validator.resourceRoot /validator/resources