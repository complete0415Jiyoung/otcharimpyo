#!/bin/bash

# Flutter Feature Generator
# Usage: ./create_feature.sh feature_name

if [ -z "$1" ]; then
    echo "Usage: ./create_feature.sh <feature_name>"
    echo "Example: ./create_feature.sh user"
    exit 1
fi

FEATURE=$1

echo "🚀 Creating feature: $FEATURE"

# Create folders
mkdir -p lib/$FEATURE/{data/{data_source,repository_impl,dto,mapper},domain/{model,repository,usecase},presentation/component,module}

# Create Data Layer files
touch lib/$FEATURE/data/data_source/${FEATURE}_data_source.dart
touch lib/$FEATURE/data/data_source/${FEATURE}_data_source_impl.dart
touch lib/$FEATURE/data/repository_impl/${FEATURE}_repository_impl.dart
touch lib/$FEATURE/data/mapper/${FEATURE}_mapper.dart
touch lib/$FEATURE/data/dto/${FEATURE}_dto.dart

# Create Domain Layer files
touch lib/$FEATURE/domain/repository/${FEATURE}_repository.dart

# Create Presentation Layer files
touch lib/$FEATURE/presentation/${FEATURE}_action.dart
touch lib/$FEATURE/presentation/${FEATURE}_state.dart
touch lib/$FEATURE/presentation/${FEATURE}_notifier.dart
touch lib/$FEATURE/presentation/${FEATURE}_screen_root.dart
touch lib/$FEATURE/presentation/${FEATURE}_screen.dart

# Create Module files
touch lib/$FEATURE/module/${FEATURE}_di.dart
touch lib/$FEATURE/module/${FEATURE}_route.dart

echo "✅ Feature structure created!"
echo ""
echo "📁 Created files:"
echo "  Data Layer:"
echo "    - ${FEATURE}_data_source.dart"
echo "    - ${FEATURE}_data_source_impl.dart"
echo "    - ${FEATURE}_repository_impl.dart"
echo "    - ${FEATURE}_mapper.dart"
echo "    - ${FEATURE}_dto.dart"
echo ""
echo "  Domain Layer:"
echo "    - ${FEATURE}_repository.dart"
echo ""
echo "  Presentation Layer:"
echo "    - ${FEATURE}_action.dart"
echo "    - ${FEATURE}_state.dart"
echo "    - ${FEATURE}_notifier.dart"
echo "    - ${FEATURE}_screen_root.dart"
echo "    - ${FEATURE}_screen.dart"
echo ""
echo "  Module:"
echo "    - ${FEATURE}_di.dart"
echo "    - ${FEATURE}_route.dart"
echo ""
echo "🔥 Next steps:"
echo "  1. Fill in the files using VSCode snippets (fdto, fmodel, etc.)"
echo "  2. Run: flutter pub run build_runner build --delete-conflicting-outputs"
