# EIRA validator

You may edit all files **except** `resources\application.properties` as this could result in errors. File `resources\application-eira.properties` contains configuration that you may want to adapt such as main XSDs and XSLTs as well as texts and labels.

To publish changes commit and push your updates. In 1-2 minutes the online service will be updated.

The online service is accessible at https://www.itb.ec.europa.eu/eira/upload and the web service API at https://www.itb.ec.europa.eu/eira/api.


XML validator documentation: https://www.itb.ec.europa.eu/docs/guides/latest/validatingXML/index.html

# Improving for the future

Review the rules that only look at something in EIRA.xml, because currently models are or may be carrying new ABBs that are not in EIRA.xml and fail when they are not.