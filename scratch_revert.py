import os
import re

def revert_log_to_print(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'developer.log(' not in content:
        return

    # Replace developer.log('[PREFIX] msg', name: 'PREFIX'); with print('[PREFIX] msg');
    # Replace developer.log('msg'); with print('msg');
    def replacer(match):
        inner_args = match.group(1)
        # inner_args is like: '[NOVA_TDLIB] API ID loaded: YES', name: 'NOVA_TDLIB'
        # extract the first string argument
        first_arg_match = re.match(r'^([^,]+)', inner_args)
        if first_arg_match:
            first_arg = first_arg_match.group(1).strip()
            return f"print({first_arg});"
        return match.group(0)

    new_content = re.sub(r'developer\.log\((.*?)\);', replacer, content)

    # Add // ignore_for_file: avoid_print at the top
    if '// ignore_for_file: avoid_print' not in new_content:
        new_content = '// ignore_for_file: avoid_print\n' + new_content

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            revert_log_to_print(os.path.join(root, file))
