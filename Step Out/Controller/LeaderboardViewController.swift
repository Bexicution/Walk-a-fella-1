import UIKit
import FirebaseDatabase
import Firebase
import CoreMotion
import FirebaseAuth

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    @IBOutlet var ListTableView: UITableView!
    @IBOutlet var YourNumOfSteps: UILabel!
    var sessionsStorage = [Person]()
    var ref = Database.database().reference()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fullName = "Sample Name"
    let user = Auth.auth().currentUser
    var counter = 0
    var initialNum = 0
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        enterMyself()
//        while(true) {
//            perform(#selector(fetchUser), with: nil, with: 5)
//        }
        fetchUser()
//        while (true) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.fetchUser()
//            }
//        }
//        if CMMotionActivityManager.isActivityAvailable() {
//            print("YES, Active")
//            self.activityManager.startActivityUpdates(to: OperationQueue.main) { (data) in
//                DispatchQueue.main.async {
//                    if let activity = data {
//                        if activity.running == true {
//                            self.YourNumOfSteps.text = "Running"
//                            print("Running")
//                        } else if activity.walking == true {
//                            self.YourNumOfSteps.text = "Walking"
//                            print("Walking")
//                        } else if activity.automotive == true {
//                            self.YourNumOfSteps.text = "Automobile"
//                            print("Automobile")
//                        }
//                    }
//                }
//            }
//        }
//        pedometer.startUpdates(from: Date()) { (pedometerData, error) in
//            if let pedData = pedometerData {
//                self.YourNumOfSteps.text = "Steps: \(pedData.numberOfSteps)"
//            } else {
//                self.YourNumOfSteps.text = "Steps: Not available"
//            }
//        }
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            self.YourNumOfSteps.text = "\(self.initialNum + Int(truncating: response.numberOfSteps))"
                            self.ref.child("Users").child("\(self.user?.uid ?? "nil")").child("steps").setValue(self.initialNum + Int(truncating: response.numberOfSteps))
                            self.fetchUser()
                        }
                    }
                }
            }
        } else {
            self.YourNumOfSteps.text = "0"
        }
    }
    
    
    
    
    
    func enterMyself() {
        ref.child("Users").child(user?.uid ?? "nil").observe(.value) { (DataSnapshot) in
            let id = DataSnapshot.value as? [String: Any]
            if id == nil {
                let object = [
                    "fullname": self.user?.displayName ?? "Sample Name",
                    "steps": 0
                ] as [String : Any]
                self.ref.child("Users").child(self.user?.uid ?? "random").setValue(object)
            }
        }
        self.ListTableView.reloadData()
    }
    func fetchUser() {
        sessionsStorage.removeAll()
        ref.child("Users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if snapshot.key == self.user?.uid {
                    self.YourNumOfSteps.text = ("\(dictionary["steps"] as! Int)")
                    if (self.flag == 0) {
                        self.initialNum = dictionary["steps"] as! Int
                        self.flag = 1
                    }
                }
               
                let steps = dictionary["steps"] as? Int
                let fullName =  dictionary["fullname"] as? String
                let fullNameArr = fullName?.components(separatedBy: " ")
                let name = fullNameArr?[0] ?? "NAME"
                let surname = fullNameArr?[1] ?? ""
               
                let user1 = Person(name: name, surname: surname, steps: steps ?? -1)
                 self.sessionsStorage.append(user1)
                 self.sessionsStorage.sort { (a:Person, b:Person) -> Bool in
                    a.steps > b.steps
                }
                self.ListTableView.reloadData()
            }
        }
    }
    
    private var data : String? // String? or any type you want
    func getData() -> String? {
        return data
    }
    func passData(_ data : String?) {
        self.data = data
    }
    @IBAction func logOut() {
        self.fetchUser()
        do {
            try Auth.auth().signOut()
            appDelegate.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            appDelegate.window?.makeKeyAndVisible()
        } catch _ {
            print("ERROR HERE")
        }
    }
    
    @IBAction func reload() {
        initialNum = 0
        self.fetchUser()
    }
    
//    @IBAction func TestingButton() {
//        self.ref.child("Users").child("\(self.user?.uid ?? "nil")").child("steps").setValue(5)
//     //   self.fetchUser()    reloading data
//        /*  signing out
//        self.fetchUser()
//
//        do {
//            try Auth.auth().signOut()
//            appDelegate.window?.rootViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//            appDelegate.window?.makeKeyAndVisible()
//        } catch _ {
//            print("ERROR HERE")
//        }
//        */
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionsStorage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: "person_cell", for: indexPath) as! LeaderboardTableViewCell
        let session = sessionsStorage[indexPath.row]
        personCell.configure(with: session)
        personCell.ratingNum.text = "\(indexPath.row + 1)"
        return personCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
}
