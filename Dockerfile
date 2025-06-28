# Use the specified Keycloak version 26.2.5
FROM quay.io/keycloak/keycloak:26.2.5 as builder

# Set environment variables for Keycloak configuration
ENV KC_DB=postgres
ENV KC_DB_URL_HOST=dpg-d1dqafbipnbc73dipe80-a
ENV KC_DB_URL_PORT=5432
ENV KC_DB_URL_DATABASE=postgress_ebqw
ENV KC_DB_USERNAME=abhay      
ENV KC_DB_PASSWORD=qBvyO1n5xPxdAgZfPqGilmUUKOz4x3pT

# Updated with your service name
ENV KC_HOSTNAME=keycloak-si6z.onrender.com
ENV KC_HOSTNAME_ADMIN=keycloak-si6z.onrender.com
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=8080
ENV KC_PROXY=passthrough

# Set dynamic port (Render exposes via $PORT)
ENV PORT=10000
ENV KC_HTTP_PORT=$PORT

# Build the Keycloak server with Postgres support
RUN /opt/keycloak/bin/kc.sh build --db postgres

# Final stage for a smaller production image
FROM quay.io/keycloak/keycloak:26.2.5
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Set the entrypoint to run Keycloak in dev mode (no HTTPS needed)
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]
