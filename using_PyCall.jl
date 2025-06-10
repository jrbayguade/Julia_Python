using PyCall

# Import Python modules on Julia
np = pyimport("numpy")
sklearn = pyimport("sklearn")

# Import specific sklearn modules
train_test_split = sklearn.model_selection.train_test_split
StandardScaler = sklearn.preprocessing.StandardScaler
MLPClassifier = sklearn.neural_network.MLPClassifier
accuracy_score = sklearn.metrics.accuracy_score

# Load "Iris" dataset
iris = sklearn.datasets.load_iris()
X = iris["data"]   # variables
y = iris["target"] # target

# Variable standardization
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Create train and test splits
X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.3)

# Convert to Numpy arrays
X_train = np.array(X_train)
X_test = np.array(X_test)
y_train = np.array(y_train)
y_test = np.array(y_test)

# Build and train an MLPClassifier (a simple neural network)
model = MLPClassifier(hidden_layer_sizes=(64, 64), max_iter=100, random_state=42)
model.fit(X_train, y_train)

# Predict and evaluate
y_pred = model.predict(X_test)
acc = accuracy_score(y_test, y_pred)

println("Accuracy:", acc)