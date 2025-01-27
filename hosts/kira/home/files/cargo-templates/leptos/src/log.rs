#[derive(Debug, Default, Clone, Copy, clap::ValueEnum)]
pub enum LogFormat {
    #[default]
    Basic,
    Pretty,
    Json,
}

pub fn setup_logger(log_format: LogFormat) {
    use tracing_error::ErrorLayer;
    use tracing_subscriber::prelude::*;
    use tracing_subscriber::{
        filter::LevelFilter,
        fmt::{self, format},
        EnvFilter,
    };

    let fmt_layer = fmt::layer()
        .without_time()
        .with_target(false)
        .with_writer(std::io::stderr);
    let fmt_layer = match log_format {
        LogFormat::Basic => fmt_layer.boxed(),
        LogFormat::Pretty => fmt_layer.pretty().boxed(),
        LogFormat::Json => fmt_layer.json().boxed(),
    };

    let filter_layer = EnvFilter::builder()
        .with_default_directive(LevelFilter::INFO.into())
        .from_env_lossy();

    let error_layer = match log_format {
        LogFormat::Basic => ErrorLayer::default().boxed(),
        LogFormat::Pretty => ErrorLayer::new(format::Pretty::default()).boxed(),
        LogFormat::Json => ErrorLayer::new(format::JsonFields::default()).boxed(),
    };

    tracing_subscriber::registry()
        .with(filter_layer)
        .with(error_layer)
        .with(fmt_layer)
        .init();
}
