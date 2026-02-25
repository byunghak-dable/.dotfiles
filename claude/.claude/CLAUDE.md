# General Rules (일반 규칙)

- **접근법 거부 시**: 즉시 멈추고 방향을 물어볼 것. 대안을 반복적으로 추측하지 말 것
- **변경 범위**: 명시적으로 요청된 것만 변경할 것. 추가 개선이 필요하다고 판단되면 먼저 물어볼 것
- **정보의 정확성**: 소스 코드나 문서를 통해 확인되지 않은 정보를 사실처럼 제시하지 말 것. 불확실하면 명시적으로 밝힐 것
- **커밋 금지**: 명시적으로 요청받기 전까지 절대 커밋하지 말 것
- **리팩토링 접근법**: 항상 가장 단순한 방법을 먼저 시도할 것. 메서드 분리나 불필요한 복잡성 추가 금지. 사용자가 접근법을 거부하면 완전히 롤백한 후 대안 시도
- **코드 수정 전 검증**: 수정 제안 전 반드시 관련 코드를 실제로 읽어 가정을 검증할 것. 타입·인터페이스·근본 원인 등을 코드 확인 없이 추측하지 말 것
- **파일 수정 후 Formatter 실행**: 코드 파일을 수정한 후 반드시 해당 프로젝트의 formatter를 실행할 것. 프로젝트 설정 파일을 확인하여 적절한 formatter를 판단:
  - Python: `ruff format` (pyproject.toml에 ruff 설정이 있는 경우), `black` (black 설정이 있는 경우), `isort` (import 정렬)
  - TypeScript/JavaScript: `prettier --write` (prettier 설정이 있는 경우), `eslint --fix` (eslint 설정이 있는 경우)
  - 프로젝트에 `Makefile`, `package.json` scripts, `pyproject.toml` 등에 format 관련 명령어가 있으면 그것을 우선 사용
  - formatter 설정을 찾을 수 없으면 사용자에게 어떤 formatter를 사용할지 물어볼 것

# Communication Guidelines (커뮤니케이션 가이드)

## Language Rules (언어 규칙)

- All responses and explanations: **Korean** (모든 응답과 설명은 한국어)
- Technical terms: Keep as **English** (기술 용어는 영문 유지: TypeScript, Express, OpenRTB)
- Error messages: **English only** (에러 메시지는 영어)
- Code comments: **Korean**, focus on **intent** not description (한국어, 의도 중심)
- Provide **context-focused technical answers** without verbosity (맥락 중심의 기술적 답변)

# Python Coding Guidelines

## 패키지 구조 (Package Structure)

### `__init__.py` 파일 사용 금지

- **규칙**: `__init__.py` 파일을 사용하지 않습니다
- **이유**: Python 3.3+ 에서는 Namespace Packages를 사용하여 `__init__.py` 없이도 패키지 구성 가능
- **장점**:
  - 더 간결한 패키지 구조
  - 네임스페이스 패키지의 유연성 활용
  - 불필요한 boilerplate 코드 제거

```
# ❌ Bad - 전통적인 패키지 구조
myproject/
├── mypackage/
│   ├── __init__.py
│   ├── module1.py
│   └── module2.py

# ✅ Good - Namespace Package 구조
myproject/
├── mypackage/
│   ├── module1.py
│   └── module2.py
```

**사용 방법:**

```python
# 직접 모듈 import
from mypackage.module1 import MyClass
from mypackage.module2 import my_function
```

## 명명 규칙 (Naming Conventions)

### 속성 접근 제어자 (Attribute Access Modifiers)

#### Private 속성

- **규칙**: `__attribute_name` (double underscore prefix)
- **용도**: 클래스 내부에서만 사용되는 속성
- **특징**: Name mangling으로 외부 접근 방지

```python
class BankAccount:
    def __init__(self, account_number, balance):
        self.__account_number = account_number  # Private
        self.__balance = balance  # Private

    def get_balance(self):
        return self.__balance  # 내부에서만 접근 가능
```

#### Protected 속성

- **규칙**: `_attribute_name` (single underscore prefix)
- **용도**: 서브클래스에서 접근 가능하지만 외부에서는 사용하지 않아야 하는 속성
- **특징**: 관례상 내부 API로 간주

```python
class Vehicle:
    def __init__(self, brand, model):
        self._brand = brand  # Protected
        self._model = model  # Protected

class Car(Vehicle):
    def get_info(self):
        return f"{self._brand} {self._model}"  # 서브클래스에서 접근 가능
```

#### Public 속성

- **규칙**: `attribute_name` (prefix 없음)
- **용도**: 외부에서 자유롭게 사용 가능한 공개 속성

```python
class Person:
    def __init__(self, name, age):
        self.name = name  # Public
        self.age = age  # Public

person = Person("John", 30)
print(person.name)  # 외부에서 자유롭게 접근 가능
```

### 메소드 접근 제어자 (Method Access Modifiers)

#### Private 메소드

- **규칙**: `__method_name` (double underscore prefix)
- **용도**: 클래스 내부에서만 사용되는 메소드
- **특징**: Name mangling으로 외부 접근 방지

```python
class Example:
    def __private_method(self):
        """완전히 비공개인 메소드"""
        pass

    def public_method(self):
        self.__private_method()  # 내부에서만 호출 가능
```

#### Protected 메소드

- **규칙**: `_method_name` (single underscore prefix)
- **용도**: 서브클래스에서 접근 가능하지만 외부에서는 사용하지 않아야 하는 메소드
- **특징**: 관례상 내부 API로 간주

```python
class Parent:
    def _protected_method(self):
        """상속받은 클래스에서 사용 가능"""
        pass

class Child(Parent):
    def public_method(self):
        self._protected_method()  # 서브클래스에서 접근 가능
```

#### Public 메소드

- **규칙**: `method_name` (prefix 없음)
- **용도**: 외부에서 자유롭게 사용 가능한 공개 API

```python
class Example:
    def public_method(self):
        """누구나 호출 가능한 공개 메소드"""
        pass
```

## OOP 원칙 (OOP Principles)

프로젝트 레벨 작업 시 반드시 다음 객체지향 프로그래밍 원칙을 준수해야 합니다.

### 1. SOLID 원칙

#### S - Single Responsibility Principle (단일 책임 원칙)

하나의 클래스는 하나의 책임만 가져야 합니다.

```python
# ❌ Bad
class UserManager:
    def __init__(self):
        self.__users = []  # Private 속성

    def create_user(self, data):
        # 사용자 생성, 이메일 전송, 리포트 생성 모두 처리
        pass

    def send_email(self, user): pass
    def generate_report(self, user): pass

# ✅ Good
class UserManager:
    def __init__(self):
        self.__users = []  # Private 속성

    def create_user(self, data):
        # 오직 사용자 생성만 담당
        pass

    @property
    def user_count(self):
        return len(self.__users)

class EmailService:
    def __init__(self, smtp_config):
        self.__smtp_config = smtp_config  # Private 속성

    def send_email(self, user):
        # 오직 이메일 전송만 담당
        pass

class ReportGenerator:
    def __init__(self, report_format):
        self.__format = report_format  # Private 속성

    def generate_report(self, user):
        # 오직 리포트 생성만 담당
        pass
```

#### O - Open/Closed Principle (개방-폐쇄 원칙)

확장에는 열려있고, 수정에는 닫혀있어야 합니다.

```python
from abc import ABC, abstractmethod

class PaymentProcessor(ABC):
    def __init__(self, amount):
        self._amount = amount  # Protected 속성

    @abstractmethod
    def process_payment(self): pass

class CreditCardPayment(PaymentProcessor):
    def __init__(self, amount, card_number):
        super().__init__(amount)
        self.__card_number = card_number  # Private 속성

    def process_payment(self):
        return f"Processing ${self._amount} via Credit Card ending in {self.__card_number[-4:]}"

class PayPalPayment(PaymentProcessor):
    def __init__(self, amount, email):
        super().__init__(amount)
        self.__email = email  # Private 속성

    def process_payment(self):
        return f"Processing ${self._amount} via PayPal ({self.__email})"

class CryptoPayment(PaymentProcessor):
    def __init__(self, amount, wallet_address):
        super().__init__(amount)
        self.__wallet_address = wallet_address  # Private 속성

    def process_payment(self):
        return f"Processing ${self._amount} via Crypto to {self.__wallet_address}"
```

#### L - Liskov Substitution Principle (리스코프 치환 원칙)

부모 클래스는 자식 클래스로 치환 가능해야 합니다.

```python
class Bird:
    def __init__(self, name):
        self._name = name  # Protected 속성
        self.__speed = 0  # Private 속성

    def move(self):
        pass

    @property
    def name(self):
        return self._name

class Sparrow(Bird):
    def __init__(self, name):
        super().__init__(name)
        self.__altitude = 0  # Private 속성

    def move(self):
        self.__altitude = 100
        return f"{self._name} is flying at {self.__altitude}m"

class Penguin(Bird):
    def __init__(self, name):
        super().__init__(name)
        self.__depth = 0  # Private 속성

    def move(self):
        self.__depth = 50
        return f"{self._name} is swimming at {self.__depth}m depth"

# 모든 Bird는 move()로 일관되게 동작
def make_bird_move(bird: Bird):
    print(bird.move())
```

#### I - Interface Segregation Principle (인터페이스 분리 원칙)

클라이언트는 사용하지 않는 메소드에 의존하지 않아야 합니다.

```python
# ❌ Bad
class Worker(ABC):
    @abstractmethod
    def work(self): pass

    @abstractmethod
    def eat(self): pass

# ✅ Good
class Workable(ABC):
    @abstractmethod
    def work(self): pass

class Eatable(ABC):
    @abstractmethod
    def eat(self): pass

class Human(Workable, Eatable):
    def __init__(self, name):
        self.__name = name  # Private 속성
        self.__energy = 100  # Private 속성

    def work(self):
        self.__energy -= 10
        return f"{self.__name} is working"

    def eat(self):
        self.__energy += 20
        return f"{self.__name} is eating"

class Robot(Workable):
    def __init__(self, model):
        self.__model = model  # Private 속성
        self.__battery = 100  # Private 속성

    def work(self):
        self.__battery -= 5
        return f"{self.__model} is working"
```

#### D - Dependency Inversion Principle (의존성 역전 원칙)

구체화가 아닌 추상화에 의존해야 합니다.

```python
# ❌ Bad
class MySQLDatabase:
    def connect(self): pass

class UserRepository:
    def __init__(self):
        self.__db = MySQLDatabase()  # 구체 클래스에 의존

    def save_user(self, user):
        self.__db.connect()

# ✅ Good
class Database(ABC):
    @abstractmethod
    def connect(self): pass

class MySQLDatabase(Database):
    def connect(self): pass

class PostgreSQLDatabase(Database):
    def connect(self): pass

class UserRepository:
    def __init__(self, database: Database):
        self.__database = database  # 추상화에 의존 (Private 속성)

    def save_user(self, user):
        self.__database.connect()
```

### 2. 캡슐화 (Encapsulation)

데이터와 메소드를 하나로 묶고, 외부로부터 내부 구현을 숨깁니다.

```python
class BankAccount:
    def __init__(self, account_number, initial_balance):
        self.__account_number = account_number  # Private 속성
        self.__balance = initial_balance  # Private 속성
        self.__transaction_history = []  # Private 속성

    def deposit(self, amount):
        """Public 메소드"""
        if amount > 0:
            self.__balance += amount
            self.__record_transaction("deposit", amount)
            return True
        return False

    def withdraw(self, amount):
        """Public 메소드"""
        if 0 < amount <= self.__balance:
            self.__balance -= amount
            self.__record_transaction("withdraw", amount)
            return True
        return False

    def __record_transaction(self, type, amount):
        """Private 메소드"""
        self.__transaction_history.append({
            "type": type,
            "amount": amount
        })

    @property
    def balance(self):
        """Read-only access to private balance"""
        return self.__balance

    @property
    def account_number(self):
        """Read-only access to private account number"""
        return self.__account_number
```

### 3. 상속 (Inheritance)

기존 클래스의 기능을 재사용하고 확장합니다.

```python
class Animal:
    def __init__(self, name, species):
        self.name = name  # Public 속성
        self._species = species  # Protected 속성

    def speak(self):
        pass

class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name, "Dog")
        self.__breed = breed  # Private 속성

    def speak(self):
        return f"{self.name} says Woof!"

    @property
    def breed(self):
        return self.__breed

class Cat(Animal):
    def __init__(self, name, color):
        super().__init__(name, "Cat")
        self.__color = color  # Private 속성

    def speak(self):
        return f"{self.name} says Meow!"

    @property
    def color(self):
        return self.__color
```

### 4. 다형성 (Polymorphism)

동일한 인터페이스로 다양한 객체를 다룹니다.

```python
def make_animals_speak(animals: list[Animal]):
    for animal in animals:
        print(animal.speak())

animals = [
    Dog("Buddy", "Golden Retriever"),
    Cat("Whiskers", "White"),
    Dog("Max", "Bulldog")
]
make_animals_speak(animals)  # 각 동물이 자신의 방식으로 소리냄
```

### 5. 추상화 (Abstraction)

복잡한 시스템에서 핵심적인 개념만 추출합니다.

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    def __init__(self, color):
        self._color = color  # Protected 속성

    @abstractmethod
    def area(self): pass

    @abstractmethod
    def perimeter(self): pass

    @property
    def color(self):
        return self._color

class Rectangle(Shape):
    def __init__(self, width, height, color):
        super().__init__(color)
        self.__width = width  # Private 속성
        self.__height = height  # Private 속성

    def area(self):
        return self.__width * self.__height

    def perimeter(self):
        return 2 * (self.__width + self.__height)

    @property
    def width(self):
        return self.__width

    @property
    def height(self):
        return self.__height
```

## 추가 모범 사례

### 1. 프로퍼티 사용

Private/Protected 속성에 대한 접근 제어

```python
class Person:
    def __init__(self, name, age, ssn):
        self.name = name  # Public 속성
        self._email = None  # Protected 속성
        self.__ssn = ssn  # Private 속성
        self.__age = age  # Private 속성

    @property
    def age(self):
        """Private 속성에 대한 읽기 전용 접근"""
        return self.__age

    @age.setter
    def age(self, value):
        """유효성 검사를 통한 제어된 쓰기"""
        if value < 0:
            raise ValueError("Age cannot be negative")
        self.__age = value

    @property
    def email(self):
        """Protected 속성에 대한 접근"""
        return self._email

    @email.setter
    def email(self, value):
        if "@" not in value:
            raise ValueError("Invalid email format")
        self._email = value
```

### 2. Dunder 메소드 활용

객체의 동작을 파이썬스럽게 정의

```python
class Vector:
    def __init__(self, x, y):
        self.__x = x  # Private 속성
        self.__y = y  # Private 속성

    def __add__(self, other):
        return Vector(self.__x + other.__x, self.__y + other.__y)

    def __repr__(self):
        return f"Vector({self.__x}, {self.__y})"

    def __eq__(self, other):
        return self.__x == other.__x and self.__y == other.__y

    @property
    def x(self):
        return self.__x

    @property
    def y(self):
        return self.__y
```

### 3. 타입 힌팅

코드의 명확성과 유지보수성 향상

```python
from typing import List, Optional, Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

class Canvas:
    def __init__(self):
        self.__shapes: List[Drawable] = []  # Private 속성
        self._max_shapes: int = 100  # Protected 속성

    def add_shape(self, shape: Drawable) -> None:
        """Public 메소드"""
        if len(self.__shapes) < self._max_shapes:
            self.__shapes.append(shape)

    def render(self) -> None:
        """Public 메소드"""
        for shape in self.__shapes:
            shape.draw()

    @property
    def shape_count(self) -> int:
        """Private 속성에 대한 읽기 전용 접근"""
        return len(self.__shapes)
```

### 4. 컴포지션 우선

상속보다 컴포지션을 선호

```python
# ✅ Good - Composition
class Engine:
    def __init__(self, horsepower):
        self.__horsepower = horsepower  # Private 속성

    def start(self):
        return f"Engine started with {self.__horsepower}hp"

class Car:
    def __init__(self, brand, engine: Engine):
        self.brand = brand  # Public 속성
        self.__engine = engine  # Private 속성 (Has-a relationship)

    def start(self):
        return self.__engine.start()

    @property
    def engine_info(self):
        return self.__engine

# ❌ Less flexible - Inheritance
class Car(Engine):  # Is-a relationship
    pass
```

### 5. 불필요한 Optional/None 분기 금지 (No Unnecessary Optional Branching)

런타임에 항상 존재하는 값에 `Optional`을 사용하여 불필요한 `if/else` 분기를 만들지 않습니다.
config나 필수 의존성이 항상 존재해야 한다면 **타입을 필수로 선언**하고, 누락 시 **조기에 실패(fail-fast)** 하도록 합니다.

```python
# ❌ Bad - 항상 존재하는 값에 Optional 사용 → 불필요한 분기 증가
class TrainingData:
    sample_weights: Optional[pd.Series] = None  # 항상 있는 값인데 Optional

# 호출부에서 매번 분기 필요
if sample_weights is not None:
    train_test_split(X, y, sample_weights, ...)
else:
    train_test_split(X, y, ...)

# ✅ Good - 필수 값은 필수 타입으로 선언, 누락 시 조기 실패
class TrainingData:
    sample_weights: pd.Series  # 필수

# 설정 검증은 진입점에서 한 번만
time_decay_config = config_store.get("time_decay")
if not time_decay_config.enabled:
    raise ValueError("time_decay must be enabled")

# 이후 로직은 분기 없이 단순
train_test_split(X, y, training_data.sample_weights, ...)
```

**원칙:**

- **실행 흐름상 항상 존재하는 값**에는 `Optional`을 사용하지 않음
- 필수 조건은 **진입점(use case 등)에서 검증**하고 `raise`로 조기 실패
- config flag로 on/off 가능했던 기능이 **사실상 항상 on**이면 `Optional` 제거 후 필수화
- 동일 메서드 내에서 직전에 할당한 변수에 대한 `is not None` 체크 불필요

## 요약

1. **`__init__.py` 사용 금지** - Namespace Packages 사용
2. **속성 및 메소드 접근 제어:**
   - **Private**: `__name` - 클래스 내부에서만 사용
   - **Protected**: `_name` - 서브클래스에서 사용 가능
   - **Public**: `name` - 외부에서 자유롭게 사용
3. **프로젝트 레벨에서는 SOLID 원칙을 포함한 OOP 원칙을 엄격히 준수**
4. **캡슐화, 상속, 다형성, 추상화를 적절히 활용**
5. **불필요한 Optional 분기 금지** - 필수 값은 필수 타입, 조기 실패 원칙

# TypeScript Coding Guidelines

## Object Destructuring 우선 사용

객체의 속성에 접근할 때는 Object Destructuring을 우선적으로 사용합니다.

### 함수 파라미터 Destructuring

함수 내부에서 객체의 여러 속성을 사용할 때, 파라미터 레벨에서 destructuring합니다.

```typescript
// ❌ Bad - dot notation 반복
function createSecret(tablePath: TableConfig, dek: string) {
  const secretName = `${prefix}:${tablePath.path}`;
  const description = `DEK for: ${tablePath.path}`;
  const server = tablePath.server;
  const db = tablePath.db;
}

// ✅ Good - 파라미터에서 destructuring
function createSecret({ server, db, table, path }: TableConfig, dek: string) {
  const secretName = `${prefix}:${path}`;
  const description = `DEK for: ${path}`;
}
```

### 변수 할당 Destructuring

객체에서 필요한 속성만 추출하여 사용합니다.

```typescript
// ❌ Bad
const path = tablePath.path;
const server = tablePath.server;

// ✅ Good
const { path, server } = tablePath;
```

### 예외: 객체 자체도 함께 필요한 경우

Destructuring 후 원본 객체도 전달해야 하는 경우에는, 속성만 별도로 destructuring합니다.

```typescript
// ✅ Good - path만 필요하지만 원본 객체도 다른 함수에 전달
function fetch(tablePath: TableConfig): Promise<string> {
  const { path } = tablePath;
  return cacheManager.wrap(`dek:${path}`, () => storageClient.fetch(tablePath));
}
```

## 파라미터 3개 이상이면 Object 형태로 전달

함수/메서드의 파라미터가 3개 이상이면 Object 형태로 받습니다.
공개 API(interface, public method)에서 사용하는 파라미터 객체는 `type.ts`에 named type으로 정의합니다.

```typescript
// ❌ Bad - 파라미터 3개
encryptFields(tableConfig: SensitiveTableConfig, data: T, keys: string[]): Promise<T>

// ✅ Good - Object로 묶어서 전달, 공유 타입 정의
// type.ts
export type FieldCipherParams<T extends Record<string, unknown>> = {
  tableConfig: SensitiveTableConfig;
  data: T;
  keys: string[];
};

// interface
encryptFields<T extends Record<string, unknown>>(params: FieldCipherParams<T>): Promise<T>

// implementation
async encryptFields<T extends Record<string, unknown>>({ tableConfig, data, keys }: FieldCipherParams<T>): Promise<T>
```

## Early Return은 반드시 블록으로 작성

단일 라인 Early Return은 지양하고, 항상 중괄호 블록을 사용합니다.

```typescript
// ❌ Bad - 단일 라인 early return
if (!(head in obj)) return;
if (typeof next !== "object" || next === null) return;

// ✅ Good - 블록으로 명시
if (!(head in obj)) {
  return;
}
if (typeof next !== "object" || next === null) {
  return;
}
```

## 길이/존재 여부는 Truthy/Falsy로 확인

`=== 0` 비교 대신 `!` 연산자를, `!== ''` 비교 대신 truthy check를 사용합니다.

```typescript
// ❌ Bad
if (tail.length === 0) { ... }
if (typeof value === 'string' && value !== '') { ... }

// ✅ Good
if (!tail.length) { ... }
if (typeof value === 'string' && value) { ... }
```

- 배열/문자열 길이가 0인지 확인: `arr.length === 0` → `!arr.length`
- 타입이 이미 `string`으로 보장된 경우 빈 문자열 여부: `value !== ''` → `value`

## 상수 네이밍

상수는 UPPER_SNAKE_CASE를 사용합니다. 객체 내 상수 프로퍼티도 동일하게 적용합니다.

```typescript
// ❌ Bad
const cipherTableConfigMap = { ... };
export const CIPHER_TABLE_CONFIG_MAP = {
  ACCOUNT_REQUEST: {
    tableConfig: ...,
    jsonFields: [...],
  },
};

// ✅ Good
export const CIPHER_TABLE_CONFIG_MAP = {
  ACCOUNT_REQUEST: {
    TABLE_CONFIG: ...,
    JSON_FIELDS: [...],
  },
};
```

## 문자열 결합

구분자가 있는 문자열 결합은 `.join()`을 사용합니다.

```typescript
// ❌ Bad
const result = a + ":" + b + ":" + c;

// ✅ Good
const result = [a, b, c].join(":");
```

## 타입 처리 (TypeScript Generics)

Type casting 대신 reduce generics를 사용합니다.

```typescript
// ❌ Bad
const result = obj as SomeType;

// ✅ Good
function process<T extends SomeBase>(obj: T): T { ... }
```

# Error Handling

- **기본 원칙**: validation 실패 시 skip/warn이 아닌 `raise` (fail-fast)
- 명시적으로 lenient handling을 요청받은 경우에만 예외
- 불필요한 try-catch 래핑 금지

```python
# ❌ Bad - skip or warn
if not config.enabled:
    logger.warning("config disabled, skipping")
    return

# ✅ Good - fail-fast
if not config.enabled:
    raise ValueError("config must be enabled")
```

# Database Guidelines

- **MySQL DDL 제약**: MySQL 5.x는 `mediumtext` / `longtext` 컬럼에 `DEFAULT` 값 설정 불가. DDL 변경 제안 전 반드시 DB 버전 확인 필요
