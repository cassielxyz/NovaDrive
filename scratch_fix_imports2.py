import os

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            if 'NovaLogger' in content and 'nova_logger.dart' not in content:
                parts = file_path.replace('\\', '/').split('/lib/')
                if len(parts) > 1:
                    depth = len(parts[1].split('/')) - 1
                    rel_path = '../' * depth + 'core/services/nova_logger.dart'
                    # clean rel_path for root files
                    if depth == 0:
                        rel_path = 'core/services/nova_logger.dart'
                    
                    lines = content.split('\n')
                    last_import_idx = -1
                    for i, line in enumerate(lines):
                        if line.startswith('import '):
                            last_import_idx = i
                    
                    if last_import_idx != -1:
                        lines.insert(last_import_idx + 1, f"import '{rel_path}';")
                    else:
                        lines.insert(0, f"import '{rel_path}';")
                    
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write('\n'.join(lines))
