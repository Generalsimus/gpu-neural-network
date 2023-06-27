
typedef struct person_t {
  char* firstName;
  char* lastName;
  int  age;
} person_t;

person_t* person_new() {
    return (person_t*)malloc(sizeof(person_t));
} 