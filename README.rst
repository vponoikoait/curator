.. _readme:


Curator
=======

Have indices in Elasticsearch? This is the tool for you!

Like a museum curator manages the exhibits and collections on display,
Elasticsearch Curator helps you curate, or manage your indices.

ANNOUNCEMENT
------------

Curator is breaking into version dependent releases. Curator 6.x will work with
Elasticsearch 6.x, Curator 7.x will work with Elasticsearch 7.x, and when it is
released, Curator 8.x will work with Elasticsearch 8.x.

Watch this space for updates when that is coming.

Additional support for Elasticsearch 7.14.0 - 7.17.x
****************************************************

Starting with Curator 8.0.18, Curator 8 can execute against Elasticsearch versions
7.14.0 - 7.17.x in addition to all versions of Elasticsearch 8.x.

Improved Action Logging (8.0.26)
********************************

Starting with Curator 8.0.26, singleton CLI actions (``curator_cli``) now produce clear,
human-readable log messages written directly to stderr. This ensures visibility regardless
of how ``es_client`` configures the Python logging framework.

Example output when no indices match::

    INFO curator Action "delete_indices" - nothing to do: no indices matched the provided filters.
    INFO curator "delete_indices" action completed.

Example output when indices are deleted::

    INFO curator Starting action "delete_indices"...
    INFO curator Action "delete_indices" will act on 3 matching index(es): ['filebeat-2026.04.17', ...]
    INFO curator "delete_indices" action completed.

Errors during connection or execution are also reported to stderr::

    ERROR curator delete_indices failed: Failed to get indices. Error: Connection timed out

Docker Base Image Change (8.0.26)
*********************************

Starting with Curator 8.0.26, the Docker image is based on ``debian:bookworm-slim`` instead
of Alpine Linux. This resolves TLS/SSL compatibility issues with the ``cx_Freeze`` frozen
binary and OpenSSL libraries.

New Client Configuration
------------------------

Curator now connects using the ``es_client`` Python module. This separation makes it much easier
to update the client connection portion separate from Curator. It is largely derived from the
original Curator client configuration, but with important updates.

The updated configuration file structure requires ``elasticsearch`` at the root level::

    ---
    elasticsearch:
      client:
        hosts: https://10.11.12.13:9200
        cloud_id:
        bearer_auth:
        opaque_id:
        request_timeout: 60
        http_compress:
        verify_certs:
        ca_certs:
        client_cert:
        client_key:
        ssl_assert_hostname:
        ssl_assert_fingerprint:
        ssl_version:
      other_settings:
        master_only:
        skip_version_test:
        username:
        password:
        api_key:
          id:
          api_key:

    logging:
      loglevel: INFO
      logfile: /path/to/file.log
      logformat: default
      blacklist: []

Action File Configuration
-------------------------

Action file structure is unchanged, for now. A few actions may have had the options modified a bit.
