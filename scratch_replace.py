import os
import re

def replace_print_with_logger(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'print(' not in content and 'developer.log' not in content:
        return

    # Add import for NovaLogger
    # calculate relative path for import
    # lib/core/services/nova_logger.dart
    parts = file_path.replace('\\', '/').split('/lib/')
    if len(parts) > 1:
        depth = len(parts[1].split('/')) - 1
        rel_path = '../' * depth + 'core/services/nova_logger.dart'
        if 'nova_logger.dart' not in content:
            content = f"import '{rel_path}';\n" + content

    def replacer(match):
        inner_string = match.group(1)
        # e.g. inner_string is '[NOVA_TDLIB] API ID loaded: YES'
        
        prefix_match = re.search(r"\[NOVA_([A-Z_]+)\]\s*(.*)", inner_string)
        if prefix_match:
            category = prefix_match.group(1).lower()
            msg = prefix_match.group(2)
            # category could be tdlib, upload, sync, ui, db, route
            # if category doesn't match exactly, fallback to tdlib
            if category not in ['tdlib', 'upload', 'sync', 'ui', 'db', 'route']:
                category = 'tdlib'
            return f"NovaLogger.{category}({msg});"
        else:
            return match.group(0)

    # replace print('...');
    new_content = re.sub(r"print\('\[NOVA_[^\]]+\]\s*([^']+)'\);", lambda m: f"NovaLogger.{m.group(0).split('NOVA_')[1].split(']')[0].lower()}('{m.group(1)}');", content)
    new_content = re.sub(r'print\("\[NOVA_[^\]]+\]\s*([^"]+)"\);', lambda m: f'NovaLogger.{m.group(0).split("NOVA_")[1].split("]")[0].lower()}("{m.group(1)}");', new_content)

    # Also handle string interpolation like print('[NOVA_TDLIB] Bridge mode: ');
    # We can do a simpler replacement
    new_content = re.sub(r"print\('\[NOVA_([A-Z_]+)\] (.*?)'\);", r"NovaLogger.\1('\2');", new_content)
    new_content = new_content.replace('NovaLogger.TDLIB', 'NovaLogger.tdlib')
    new_content = new_content.replace('NovaLogger.UPLOAD', 'NovaLogger.upload')
    new_content = new_content.replace('NovaLogger.SYNC', 'NovaLogger.sync')
    new_content = new_content.replace('NovaLogger.UI', 'NovaLogger.ui')
    new_content = new_content.replace('NovaLogger.DB', 'NovaLogger.db')
    new_content = new_content.replace('NovaLogger.ROUTE', 'NovaLogger.route')

    # Remove the ignore avoid_print line if present
    new_content = new_content.replace('// ignore_for_file: avoid_print\n', '')

    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            replace_print_with_logger(os.path.join(root, file))
