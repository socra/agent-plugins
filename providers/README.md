# Provider plugins

Each plugin package is isolated under `providers/<provider>/<product>`. A product has a separate package for every supported agent runtime, and each provider catalog may contain multiple Socra products.

The initial package is `providers/codex/cortex`. Add another package only when that product-and-runtime adapter is implemented and testable; directory names are not statements of future support. Do not copy credentials or generated provider registrations between adapters because each runtime may require its own integration identity.
