// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actors_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$actorsHash() => r'b31b6aa39c8894ce9bf4a3c75c7b64314b5ac5e0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [actors].
@ProviderFor(actors)
const actorsProvider = ActorsFamily();

/// See also [actors].
class ActorsFamily extends Family {
  /// See also [actors].
  const ActorsFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'actorsProvider';

  /// See also [actors].
  ActorsProvider call({
    required int movieId,
  }) {
    return ActorsProvider(
      movieId: movieId,
    );
  }

  @visibleForOverriding
  @override
  ActorsProvider getProviderOverride(
    covariant ActorsProvider provider,
  ) {
    return call(
      movieId: provider.movieId,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(FutureOr<List<Actor>> Function(ActorsRef ref) create) {
    return _$ActorsFamilyOverride(this, create);
  }
}

class _$ActorsFamilyOverride implements FamilyOverride {
  _$ActorsFamilyOverride(this.overriddenFamily, this.create);

  final FutureOr<List<Actor>> Function(ActorsRef ref) create;

  @override
  final ActorsFamily overriddenFamily;

  @override
  ActorsProvider getProviderOverride(
    covariant ActorsProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [actors].
class ActorsProvider extends AutoDisposeFutureProvider<List<Actor>> {
  /// See also [actors].
  ActorsProvider({
    required int movieId,
  }) : this._internal(
          (ref) => actors(
            ref as ActorsRef,
            movieId: movieId,
          ),
          from: actorsProvider,
          name: r'actorsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$actorsHash,
          dependencies: ActorsFamily._dependencies,
          allTransitiveDependencies: ActorsFamily._allTransitiveDependencies,
          movieId: movieId,
        );

  ActorsProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.movieId,
  }) : super.internal();

  final int movieId;

  @override
  Override overrideWith(
    FutureOr<List<Actor>> Function(ActorsRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActorsProvider._internal(
        (ref) => create(ref as ActorsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        movieId: movieId,
      ),
    );
  }

  @override
  ({
    int movieId,
  }) get argument {
    return (movieId: movieId,);
  }

  @override
  AutoDisposeFutureProviderElement<List<Actor>> createElement() {
    return _ActorsProviderElement(this);
  }

  ActorsProvider _copyWith(
    FutureOr<List<Actor>> Function(ActorsRef ref) create,
  ) {
    return ActorsProvider._internal(
      (ref) => create(ref as ActorsRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      movieId: movieId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActorsProvider && other.movieId == movieId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, movieId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActorsRef on AutoDisposeFutureProviderRef<List<Actor>> {
  /// The parameter `movieId` of this provider.
  int get movieId;
}

class _ActorsProviderElement
    extends AutoDisposeFutureProviderElement<List<Actor>> with ActorsRef {
  _ActorsProviderElement(super.provider);

  @override
  int get movieId => (origin as ActorsProvider).movieId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
