FROM httpd:2.4

# Copy custom configuration files
COPY ./httpd.conf /usr/local/apache2/conf/httpd.conf
# COPY ./rewrite-rules.conf /usr/local/apache2/conf/extra/httpd-rewrite.conf

COPY ./htdocs/ /usr/local/apache2/htdocs/
# Expose the port 80
EXPOSE 80