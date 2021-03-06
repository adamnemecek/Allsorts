//
//  Ended.swift
//  Allsorts
//
//  Copyright (c) 2015 Pyry Jahkola. All rights reserved.
//

/// Orderable value `T` augmented with an upper bound `.End`. An `Ended<T>` is
/// structurally equivalent to `Optional<T>` but flips the ordering of the
/// `Optional.Some(T)` (~ `Ended.Value(T)`) and the `Optional.None` (~
/// `Ended.End`) cases such that `.Value(x)` compares less than `.End`.
public enum Ended<T : Orderable> : Orderable, Comparable {
    case Value(T)
    case End
    
    public init() {
        self = .End
    }
    
    public init(_ value: T?) {
        self = value.map {x in .Value(x)} ?? .End
    }
    
    public var value: T? {
        switch self {
        case let .Value(x): return .Some(x)
        case     .End:      return .None
        }
    }
    
    public func map<U>(@noescape f: T -> U) -> Ended<U> {
        switch self {
        case let .Value(x): return .Value(f(x))
        case     .End:      return .End
        }
    }
    
    public func flatMap<U>(@noescape f: T -> Ended<U>) -> Ended<U> {
        switch self {
        case let .Value(x): return f(x)
        case     .End:      return .End
        }
    }
}

extension Ended : CustomStringConvertible {
    public var description: String {
        switch self {
        case let .Value(x): return "Value(\(x))"
        case     .End:      return "End"
        }
    }
}

extension Ended : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .Value(x): return "Ended.Value(\(String(reflecting: x)))"
        case     .End:      return "Ended.End"
        }
    }
}

/// Ordering based on `a <=> b == .Value(a) <=> .Value(b)` and
/// `.Value(_) < .End`.
public func <=> <T>(a: Ended<T>, b: Ended<T>) -> Ordering {
    switch (a, b) {
    case let (.Value(a), .Value(b)): return a <=> b
    case     (.Value,    .End     ): return .LT
    case     (.End,      .End     ): return .EQ
    case     (.End,      .Value   ): return .GT
    }
}
