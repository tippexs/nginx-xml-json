FROM node:alpine AS npm

WORKDIR /tmp
RUN npm install xml-js
RUN echo "global.xmljs = require('xml-js');" | npx browserify -d -o xml-js-browser.js -
RUN echo "export default {xj}\nfunction xj(){}" > export.js
RUN cat export.js xml-js-browser.js > xml-js.js

FROM nginx
COPY --from=npm /tmp/xml-js.js /etc/nginx
RUN sed -i "s/events/load_module modules\/ngx_http_js_module.so;\nevents/" /etc/nginx/nginx.conf
RUN nginx -v > /dev/stderr
RUN njs -v > /dev/stderr
