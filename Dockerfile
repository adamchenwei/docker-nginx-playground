FROM nginx
#RUN rm /etc/nginx/conf.d/examplessl.conf

#Update config
#COPY conf /etc/nginx
RUN rm /etc/nginx/conf.d/default.conf

COPY conf/default.conf /etc/nginx/conf.d/
#COPY conf-default/default.conf /etc/nginx/conf.d/

#Update Compiled Static Files
ADD dist /usr/share/nginx/html/
#COPY content /usr/share/nginx/html

#Set Port
EXPOSE 8089
