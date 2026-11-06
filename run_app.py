"""Desktop launcher: starts the local Django app and opens it in the browser."""
import os
import threading
import time
import traceback
import webbrowser
from pathlib import Path

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'automl_studio.settings')


def _show_error(message: str) -> None:
    if os.name == 'nt':
        try:
            import ctypes
            ctypes.windll.user32.MessageBoxW(0, message, 'Django AutoML Studio', 0x10)
            return
        except Exception:
            pass
    print(message)


def main():
    # Import settings first so the local data directory is available for startup logs.
    from django.conf import settings
    log_path = settings.APP_DATA_ROOT / 'startup.log'
    try:
        from django.core.management import call_command
        from waitress import serve
        from automl_studio.wsgi import application

        call_command('migrate', interactive=False, verbosity=0)
        url = 'http://127.0.0.1:8765'
        threading.Timer(1.5, lambda: webbrowser.open(url)).start()
        serve(application, host='127.0.0.1', port=8765, threads=8, url_scheme='http')
    except Exception as exc:
        details = f'[{time.strftime("%Y-%m-%d %H:%M:%S")}] {type(exc).__name__}: {exc}\n{traceback.format_exc()}\n'
        try:
            with log_path.open('a', encoding='utf-8') as handle:
                handle.write(details)
        except Exception:
            pass
        _show_error(f'The app could not start.\n\n{type(exc).__name__}: {exc}\n\nLog file: {log_path}')


if __name__ == '__main__':
    main()
